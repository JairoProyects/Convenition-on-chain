package com.zkbytebandits.convenio.controller.convenio;

import com.zkbytebandits.convenio.dto.convenio.CreateConvenioRequest;
import com.zkbytebandits.convenio.dto.convenio.ConvenioResponse;
import com.zkbytebandits.convenio.dto.convenio.UpdateConvenioRequest;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.mapper.convenio.ConvenioMapper;
import com.zkbytebandits.convenio.service.convenio.create.CreateConvenioService;
import com.zkbytebandits.convenio.service.convenio.delete.DeleteConvenioService;
import com.zkbytebandits.convenio.service.convenio.get.GetConvenioService;
import com.zkbytebandits.convenio.service.convenio.update.UpdateConvenioService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/convenios")
public class ConvenioController {

    private final CreateConvenioService createConvenioService;
    private final GetConvenioService getConvenioService;
    private final UpdateConvenioService updateConvenioService;
    private final DeleteConvenioService deleteConvenioService;
    private final ConvenioMapper convenioMapper;

    @Autowired
    public ConvenioController(CreateConvenioService createConvenioService,
                              GetConvenioService getConvenioService,
                              UpdateConvenioService updateConvenioService,
                              DeleteConvenioService deleteConvenioService,
                              ConvenioMapper convenioMapper) {
        this.createConvenioService = createConvenioService;
        this.getConvenioService = getConvenioService;
        this.updateConvenioService = updateConvenioService;
        this.deleteConvenioService = deleteConvenioService;
        this.convenioMapper = convenioMapper;
    }

    @PostMapping
    public ResponseEntity<ConvenioResponse> createConvenio(@Valid @RequestBody CreateConvenioRequest request) {
        Convenio convenio = createConvenioService.createConvenio(request);
        return new ResponseEntity<>(convenioMapper.toConvenioResponse(convenio), HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<Page<ConvenioResponse>> getAllConvenios(Pageable pageable) {
        Page<Convenio> conveniosPage = getConvenioService.getAllConvenios(pageable);
        Page<ConvenioResponse> convenioResponsePage = conveniosPage.map(convenioMapper::toConvenioResponse);
        return ResponseEntity.ok(convenioResponsePage);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ConvenioResponse> getConvenioById(@PathVariable Long id) {
        return getConvenioService.getConvenioById(id)
                .map(convenioMapper::toConvenioResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/external/{externalId}")
    public ResponseEntity<ConvenioResponse> getConvenioByExternalId(@PathVariable String externalId) {
        return getConvenioService.getConvenioByExternalId(externalId)
                .map(convenioMapper::toConvenioResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/hash/{onChainHash}")
    public ResponseEntity<ConvenioResponse> getConvenioByOnChainHash(@PathVariable String onChainHash) {
        return getConvenioService.getConvenioByOnChainHash(onChainHash)
                .map(convenioMapper::toConvenioResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<ConvenioResponse> updateConvenio(@PathVariable Long id, @Valid @RequestBody UpdateConvenioRequest request) {
        Convenio updatedConvenio = updateConvenioService.updateConvenio(id, request);
        return ResponseEntity.ok(convenioMapper.toConvenioResponse(updatedConvenio));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteConvenio(@PathVariable Long id) {
        deleteConvenioService.deleteConvenio(id);
        return ResponseEntity.noContent().build();
    }
} 