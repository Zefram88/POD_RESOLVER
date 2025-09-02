# Changelog

Tutte le modifiche notevoli a questo progetto saranno documentate in questo file.

Il formato è basato su [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e questo progetto aderisce al [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Supporto per Python 3.8+
- Interfaccia web standalone
- Modulo Python per integrazione
- Mappature complete ISTAT per regioni e province
- Query spaziali per identificazione comuni
- Gestione automatica delle risorse HTTP
- Logging completo delle operazioni
- Validazione input con regex
- Prevenzione XSS
- Design responsive per mobile/tablet/desktop

### Changed
- Nessuna modifica rispetto alle versioni precedenti

### Deprecated
- Nessuna deprecazione

### Removed
- Nessuna rimozione

### Fixed
- Nessun bug noto

### Security
- Validazione input rigorosa
- Escape HTML per prevenzione XSS
- Timeout configurabili per protezione da hanging

## [1.0.0] - 2024-12-19

### Added
- **Rilascio iniziale** del GSE POD Resolver
- **Modulo Python** (`gse_pod_resolver.py`) con:
  - Classe `GSEPodResolver` per risoluzione POD
  - Dataclass `PODResult` per risultati strutturati
  - Supporto context manager (`with` statement)
  - Mappature ISTAT complete per regioni e province
  - Gestione automatica sessioni HTTP
  - Logging dettagliato delle operazioni
  - Timeout configurabili
  - Gestione robusta degli errori

- **Interfaccia Web** (`pod_resolver_web.html`) con:
  - Design moderno e responsive
  - Validazione input in tempo reale
  - Prevenzione XSS
  - Supporto mobile/tablet/desktop
  - Nessuna dipendenza esterna (JavaScript puro)

- **API GSE Supportate**:
  - `POD_AC/FeatureServer/12`: Mapping POD → AC
  - `Aree_Convenzionali/FeatureServer/0`: Info e geometria AC
  - `Comuni/FeatureServer/10`: Query spaziali per comuni

- **Funzionalità Core**:
  - Risoluzione POD tramite codici univoci
  - Identificazione Cabina Primaria (Area Convenzionale)
  - Estrazione nome fornitore
  - Identificazione regioni e province coinvolte
  - Lista completa comuni serviti dall'AC

### Technical Details
- **Dependencies**: Solo `requests>=2.31.0`
- **Python Support**: 3.8, 3.9, 3.10, 3.11, 3.12
- **Architecture**: Modulare, estensibile, testabile
- **Error Handling**: Gestione completa errori con logging
- **Performance**: Sessioni HTTP riutilizzabili, timeout configurabili
- **Security**: Validazione input, escape HTML, gestione sessioni sicura

### Documentation
- README completo con esempi
- Docstring dettagliate per tutte le classi e metodi
- Esempi di utilizzo per diversi scenari
- Documentazione API GSE utilizzate
- Guida installazione e setup

---

## Note di Rilascio

### Versioning
- **Major**: Cambiamenti incompatibili con versioni precedenti
- **Minor**: Nuove funzionalità compatibili con versioni precedenti
- **Patch**: Bug fixes e miglioramenti minori

### Supporto
- **LTS**: Versioni 1.x.x sono supportate a lungo termine
- **Security**: Patch di sicurezza per tutte le versioni supportate
- **Compatibility**: Mantenimento compatibilità Python 3.8+
