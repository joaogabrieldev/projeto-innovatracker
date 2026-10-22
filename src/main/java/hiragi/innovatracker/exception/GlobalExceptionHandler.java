package hiragi.innovatracker.exception;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.core.PropertyReferenceException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.validation.FieldError;
import org.springframework.web.ErrorResponse;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Tratamento global de exceções (Aula 08).
 * Linhas marcadas com 🔧 são correções em relação ao material do professor:
 * sem elas, erros do cliente (JSON quebrado, rota inexistente, método errado...)
 * caíam no fallback de Exception e voltavam como 500.
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // 404 -------------------------------------------------------------
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(ResourceNotFoundException ex,
                                                   HttpServletRequest request) {
        return build(HttpStatus.NOT_FOUND, "Recurso não encontrado", ex.getMessage(), request);
    }

    // 🔧 404 - rota que não existe (ex.: GET /api/categoriasx) ---------
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ApiError> handleRotaInexistente(NoResourceFoundException ex,
                                                          HttpServletRequest request) {
        return build(HttpStatus.NOT_FOUND, "Recurso não encontrado",
                "A rota informada não existe", request);
    }

    // 409 - regra de negócio / duplicidade ---------------------------
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiError> handleBusiness(BusinessException ex,
                                                   HttpServletRequest request) {
        return build(HttpStatus.CONFLICT, "Violação de regra de negócio", ex.getMessage(), request);
    }

    // 400 - @Valid falhou -------------------------------------------
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException ex,
                                                     HttpServletRequest request) {
        Map<String, String> campos = new LinkedHashMap<>();
        for (FieldError erro : ex.getBindingResult().getFieldErrors()) {
            campos.putIfAbsent(erro.getField(), erro.getDefaultMessage());
        }

        return ResponseEntity.badRequest().body(ApiError.of(
                HttpStatus.BAD_REQUEST.value(),
                "Erro de validação",
                "Um ou mais campos estão inválidos",
                request.getRequestURI(),
                campos));
    }

    // 400 - tipo de parâmetro incompatível --------------------------
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiError> handleTypeMismatch(MethodArgumentTypeMismatchException ex,
                                                       HttpServletRequest request) {
        String msg = "Valor inválido para o parâmetro '%s': %s".formatted(ex.getName(), ex.getValue());
        return build(HttpStatus.BAD_REQUEST, "Parâmetro inválido", msg, request);
    }

    // 🔧 400 - corpo ausente ou JSON mal formado ----------------------
    // Esta exceção NÃO implementa ErrorResponse, por isso precisa de handler próprio.
    // A mensagem é fixa de propósito: ex.getMessage() expõe detalhes internos do Jackson.
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiError> handleCorpoInvalido(HttpMessageNotReadableException ex,
                                                        HttpServletRequest request) {
        return build(HttpStatus.BAD_REQUEST, "Requisição inválida",
                "O corpo da requisição está ausente ou mal formado (confira o JSON)", request);
    }

    // 🔧 400 - campo de ordenação inexistente (?sort=xxx) -------------
    @ExceptionHandler(PropertyReferenceException.class)
    public ResponseEntity<ApiError> handleSortInvalido(PropertyReferenceException ex,
                                                       HttpServletRequest request) {
        String msg = "Campo de ordenação inválido: '%s'".formatted(ex.getPropertyName());
        return build(HttpStatus.BAD_REQUEST, "Parâmetro inválido", msg, request);
    }

    // 🔧 405 - método HTTP errado (ex.: DELETE /api/categorias) -------
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiError> handleMetodoNaoPermitido(HttpRequestMethodNotSupportedException ex,
                                                             HttpServletRequest request) {
        String msg = "O método %s não é aceito nesta rota".formatted(ex.getMethod());
        // ex.getHeaders() traz o cabeçalho "Allow" com os métodos aceitos
        return build(HttpStatus.METHOD_NOT_ALLOWED, "Método não permitido", msg, request, ex.getHeaders());
    }

    // 🔧 415 - Content-Type errado ------------------------------------
    @ExceptionHandler(HttpMediaTypeNotSupportedException.class)
    public ResponseEntity<ApiError> handleMediaType(HttpMediaTypeNotSupportedException ex,
                                                    HttpServletRequest request) {
        // ex.getHeaders() traz o cabeçalho "Accept" com os tipos aceitos
        return build(HttpStatus.UNSUPPORTED_MEDIA_TYPE, "Tipo de conteúdo não suportado",
                "Envie o corpo como application/json", request, ex.getHeaders());
    }

    // 401 / 403 - autenticação --------------------------------------
    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ApiError> handleBadCredentials(BadCredentialsException ex,
                                                         HttpServletRequest request) {
        return build(HttpStatus.UNAUTHORIZED, "Não autorizado", ex.getMessage(), request);
    }

    @ExceptionHandler(DisabledException.class)
    public ResponseEntity<ApiError> handleDisabled(DisabledException ex,
                                                   HttpServletRequest request) {
        return build(HttpStatus.FORBIDDEN, "Acesso negado", ex.getMessage(), request);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiError> handleAccessDenied(AccessDeniedException ex,
                                                       HttpServletRequest request) {
        return build(HttpStatus.FORBIDDEN, "Acesso negado", "Você não tem permissão para este recurso", request);
    }

    // 409 - constraint do banco ------------------------------------
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiError> handleDataIntegrity(DataIntegrityViolationException ex,
                                                        HttpServletRequest request) {
        log.warn("Violação de integridade: {}", ex.getMostSpecificCause().getMessage());
        return build(HttpStatus.CONFLICT, "Conflito de dados",
                "Operação viola uma restrição de integridade do banco de dados", request);
    }

    // 500 - fallback ----------------------------------------------
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleGeneric(Exception ex, HttpServletRequest request) {
        // 🔧 Rede de segurança: toda exceção do Spring MVC que já conhece o próprio
        // status 4xx (ErrorResponse) mantém esse status em vez de virar 500.
        if (ex instanceof ErrorResponse er) {
            HttpStatus status = HttpStatus.resolve(er.getStatusCode().value());
            if (status != null && status.is4xxClientError()) {
                String detalhe = Objects.requireNonNullElse(er.getBody().getDetail(), status.getReasonPhrase());
                return build(status, status.getReasonPhrase(), detalhe, request, er.getHeaders());
            }
        }

        log.error("Erro não tratado em {}", request.getRequestURI(), ex);
        return build(HttpStatus.INTERNAL_SERVER_ERROR, "Erro interno",
                "Ocorreu um erro inesperado. Contate o suporte.", request);
    }

    private ResponseEntity<ApiError> build(HttpStatus status, String erro,
                                           String mensagem, HttpServletRequest request) {
        return build(status, erro, mensagem, request, new HttpHeaders());
    }

    // 🔧 sobrecarga que repassa cabeçalhos da exceção (Allow no 405, Accept no 415)
    private ResponseEntity<ApiError> build(HttpStatus status, String erro, String mensagem,
                                           HttpServletRequest request, HttpHeaders headers) {
        return ResponseEntity.status(status)
                .headers(headers)
                .body(ApiError.of(status.value(), erro, mensagem, request.getRequestURI()));
    }
}