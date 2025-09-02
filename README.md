# 🔌 GSE POD Resolver

**Risolutore di POD (Point of Delivery) tramite servizi GSE diretti**

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg)]()

## 📋 Descrizione

GSE POD Resolver è uno strumento per risolvere i codici POD (Point of Delivery) italiani utilizzando direttamente le API GSE (Gestore Servizi Energetici). Il sistema fornisce informazioni complete su:

- **Cabina Primaria** (Area Convenzionale)
- **Fornitore** del servizio
- **Regioni** e **Province** coinvolte
- **Comuni** serviti dall'area

## 🚀 Caratteristiche

- ✅ **API Dirette GSE**: Nessun scraping, solo chiamate API ufficiali
- ✅ **Dual Interface**: Modulo Python + Interfaccia Web standalone
- ✅ **Dati ISTAT Completi**: Mappature complete regioni/province italiane
- ✅ **Query Spaziali**: Utilizzo di geometrie per identificare comuni
- ✅ **Zero Dependencies Esterne**: Solo `requests` per HTTP
- ✅ **Context Manager**: Gestione automatica delle risorse
- ✅ **Logging Completo**: Tracciamento dettagliato delle operazioni

## 🛠️ Installazione

### Prerequisiti
- Python 3.8+
- Accesso internet per le API GSE

### Setup
```bash
# Clone del repository
git clone https://github.com/username/gse-pod-resolver.git
cd gse-pod-resolver

# Creazione virtual environment
python -m venv venv

# Attivazione (Windows)
venv\Scripts\activate

# Attivazione (Linux/Mac)
source venv/bin/activate

# Installazione dipendenze
pip install -r requirements.txt
```

## 📖 Utilizzo

### Modulo Python

```python
from gse_pod_resolver import GSEPodResolver, PODResult

# Metodo 1: Utilizzo diretto
resolver = GSEPodResolver(timeout=45)
result = resolver.resolve_pod("IT001E12345678")
print(f"Fornitore: {result.fornitore}")
resolver.close()

# Metodo 2: Context manager (raccomandato)
with GSEPodResolver() as resolver:
    result = resolver.resolve_pod("IT001E12345678")
    print(f"Regioni: {result.regioni}")
    print(f"Province: {result.province}")
    print(f"Comuni: {result.comuni}")

# Metodo 3: Accesso diretto alle mappe ISTAT
resolver = GSEPodResolver()
print(f"Regione 5: {resolver.regioni_map[5]}")      # "Veneto"
print(f"Provincia 27: {resolver.province_map[27]}")  # "Venezia"
resolver.close()
```

### Interfaccia Web

1. Apri `pod_resolver_web.html` in qualsiasi browser moderno
2. Inserisci il codice POD (es: `IT001E12345678`)
3. Clicca "Risolvi POD"
4. Visualizza i risultati in tempo reale

### CLI

```bash
# Test singolo POD
python gse_pod_resolver.py IT001E12345678

# Output di esempio
🔌 GSE POD Resolver - Test
==================================================
🔍 Test POD: IT001E12345678
------------------------------
✅ POD: IT001E12345678
✅ Cabina Primaria: AC001E00001
✅ Fornitore: Fornitore Esempio S.p.A.
✅ Regioni: Regione Esempio
✅ Province: Provincia Esempio 1, Provincia Esempio 2
✅ Comuni: Comune Esempio 1, Comune Esempio 2, Comune Esempio 3
```

## 🔧 API GSE Utilizzate

### 1. POD → AC Mapping
- **Endpoint**: `POD_AC/FeatureServer/12`
- **Scopo**: Trova l'Area Convenzionale per un POD
- **Campi**: `COD_POD`, `COD_AC`

### 2. AC Geometry & Info
- **Endpoint**: `Aree_Convenzionali/FeatureServer/0`
- **Scopo**: Ottiene geometria e informazioni AC
- **Campi**: `COD_AC`, `RAG_SOC` (Fornitore), `geometry`

### 3. Comuni Intersezione
- **Endpoint**: `Comuni/FeatureServer/10`
- **Scopo**: Trova comuni che intersecano l'AC
- **Campi**: `COD_REG`, `COD_PROV`, `COMUNE`, `PRO_COM_T`

## 📊 Struttura Dati

### PODResult
```python
@dataclass
class PODResult:
    pod: str                    # Codice POD originale
    cabina_primaria: str        # Codice AC
    fornitore: str              # Nome fornitore
    regioni: List[str]          # Lista regioni
    province: List[str]         # Lista province
    comuni: List[str]           # Lista comuni
```

### Mappe ISTAT
- **regioni_map**: Codice → Nome regione (20 regioni)
- **province_map**: Codice → Nome provincia (101 province)

## 🔍 Esempi di Risoluzione

| POD | Cabina | Fornitore | Regione | Provincia | Comuni |
|-----|---------|-----------|---------|-----------|---------|
| `IT001E12345678` | `AC001E00001` | Fornitore Esempio 1 | Regione Esempio 1 | Provincia Esempio 1, Provincia Esempio 2 | 5 comuni |
| `IT002E98765432` | `AC002E00002` | Fornitore Esempio 2 | Regione Esempio 2 | Provincia Esempio 3 | 3 comuni |
| `IT003E55556666` | `AC003E00003` | Fornitore Esempio 3 | Regione Esempio 3 | Provincia Esempio 4, Provincia Esempio 5 | 7 comuni |

## 🚨 Gestione Errori

```python
try:
    with GSEPodResolver() as resolver:
        result = resolver.resolve_pod("IT001E12345678")
        print(f"✅ POD: {result.pod}")
except ValueError as e:
    print(f"❌ POD non valido: {e}")
except RuntimeError as e:
    print(f"❌ Errore di risoluzione: {e}")

## 🧪 Testing

```bash
# Test rapido
python gse_pod_resolver.py IT001E12345678

# Test multipli
python gse_pod_resolver.py IT002E98765432
python gse_pod_resolver.py IT003E55556666
```

## 📁 Struttura Progetto

```
gse-pod-resolver/
├── gse_pod_resolver.py      # 🐍 Modulo Python principale
├── pod_resolver_web.html    # 🌐 Interfaccia web standalone
├── requirements.txt          # 📦 Dipendenze Python
├── README.md                # 📖 Documentazione
├── LICENSE                  # ⚖️ Licenza
├── .gitignore              # 🚫 File da ignorare
└── venv/                   # 🐍 Virtual environment
```

## 🔒 Sicurezza

- ✅ **Validazione Input**: Regex per formato POD
- ✅ **Escape HTML**: Prevenzione XSS
- ✅ **Timeout Configurabili**: Protezione da hanging
- ✅ **Gestione Sessioni**: Riutilizzo efficiente HTTP

## 📱 Responsive Design

L'interfaccia web è ottimizzata per:
- 🖥️ Desktop (1200px+)
- 📱 Tablet (768px-1199px)
- 📱 Mobile (<768px)

## 🤝 Contribuire

1. Fork del repository
2. Creazione branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit delle modifiche (`git commit -m 'Add AmazingFeature'`)
4. Push del branch (`git push origin feature/AmazingFeature`)
5. Apertura Pull Request

## 📄 Licenza

Distribuito sotto licenza MIT. Vedi `LICENSE` per maggiori informazioni.

## 📞 Supporto

- 🐛 **Issues**: [GitHub Issues](https://github.com/username/gse-pod-resolver/issues)
- 📧 **Email**: support@example.com
- 📖 **Wiki**: [Documentazione completa](https://github.com/username/gse-pod-resolver/wiki)

## 🙏 Ringraziamenti

- **GSE** per le API pubbliche
- **ISTAT** per i dati geografici
- **Comunità Python** per le librerie

---

**⭐ Se questo progetto ti è utile, considera di dargli una stella!**
