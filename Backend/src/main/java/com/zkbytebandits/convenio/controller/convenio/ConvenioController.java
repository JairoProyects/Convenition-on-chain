package com.zkbytebandits.convenio.controller.convenio;

import com.zkbytebandits.convenio.dto.convenio.ConvenioDTO;
import com.zkbytebandits.convenio.dto.convenio.CreateConvenioRequest;
import com.zkbytebandits.convenio.dto.convenio.UpdateConvenioRequest;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.Convenio.Status;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.service.convenio.create.CreateConvenioService;
import com.zkbytebandits.convenio.service.convenio.delete.DeleteConvenioService;
import com.zkbytebandits.convenio.service.convenio.get.GetConvenioService;
import com.zkbytebandits.convenio.service.convenio.update.UpdateConvenioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/convenios")
@RequiredArgsConstructor
public class ConvenioController {

    private final CreateConvenioService createConvenioService;
    private final GetConvenioService getConvenioService;
    private final UpdateConvenioService updateConvenioService;
    private final DeleteConvenioService deleteConvenioService;


    private final ConvenioRepository convenioRepository;

    @PostMapping
    public ResponseEntity<ConvenioDTO> createConvenio(@Valid @RequestBody CreateConvenioRequest request) {
        return ResponseEntity.ok(createConvenioService.createConvenio(request));
    }

    @GetMapping
    public ResponseEntity<List<ConvenioDTO>> getAllConvenios() {
        return ResponseEntity.ok(getConvenioService.getAllConvenios());
    }
    @GetMapping("/test")
    public ResponseEntity<List<Convenio>> testConvenios() {
        return ResponseEntity.ok(convenioRepository.findAll());
    }


    @GetMapping("/{id}")
    public ResponseEntity<ConvenioDTO> getConvenioById(@PathVariable Long id) {
        return ResponseEntity.ok(getConvenioService.getConvenioById(id));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<ConvenioDTO>> getConveniosByStatus(@PathVariable Status status) {
        return ResponseEntity.ok(getConvenioService.getConveniosByStatus(status));
    }

    @GetMapping("/hash/{onChainHash}")
    public ResponseEntity<ConvenioDTO> getConvenioByOnChainHash(@PathVariable String onChainHash) {
        return ResponseEntity.ok(getConvenioService.getConvenioByOnChainHash(onChainHash));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ConvenioDTO> updateConvenio(@PathVariable Long id, @Valid @RequestBody UpdateConvenioRequest request) {
        return ResponseEntity.ok(updateConvenioService.updateConvenio(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteConvenio(@PathVariable Long id) {
        deleteConvenioService.deleteConvenio(id);
        return ResponseEntity.noContent().build();
    }
}
