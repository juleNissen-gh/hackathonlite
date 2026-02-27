# Hackathon Lite – Bruksanvisning for lag

Velkommen! Her får du alt du trenger for å bruke AI-APIet under hackathonen.

---

## Hva er dette?

I stedet for å gi alle lag direkte tilgang til Google Gemini, bruker vi en **proxy-server** som sitter i mellom. Det betyr:

- Du bruker **din egen nøkkel** (`sk-...`) – ikke en Google-nøkkel
- Du sender forespørsler til **vår server** – ikke Google direkte
- Serveren sørger for at laget ditt ikke bruker mer enn **$30**
- Du kan se forbruket ditt på dashboardet til enhver tid

```
Din kode → Hackathon Lite-serveren → Google Gemini → svar tilbake
```

---

## Hva er annerledes fra vanlig Gemini API?

| | Vanlig Gemini API | Hackathon Lite |
|---|---|---|
| Nøkkel | `AIzaSy...` (Google) | `sk-...` (din lagnøkkel) |
| Bibliotek | `google-generativeai` | `openai` ✅ |
| Base URL | Google sine servere | `https://hackathonlite-production.up.railway.app` |
| Budsjett | — | $30 per lag (automatisk stopp) |

Den store fordelen: APIet er **OpenAI-kompatibelt**, så du bruker `openai`-biblioteket i Python. Det er godt dokumentert og enkelt å bruke.

---

## Kom i gang

### Installer biblioteket

```bash
pip install openai
```

### Din konfigurasjon

```python
API_KEY  = "sk-din-nøkkel-her"          # Nøkkelen du fikk av arrangør
BASE_URL = "https://hackathonlite-production.up.railway.app"
MODEL    = "gemini-2.0-flash"            # Rask og billig – anbefalt
```

---

## Kodeeksempler

### Enkel melding (én forespørsel)

```python
from openai import OpenAI

client = OpenAI(
    api_key="sk-din-nøkkel-her",
    base_url="https://hackathonlite-production.up.railway.app",
)

response = client.chat.completions.create(
    model="gemini-2.0-flash",
    messages=[
        {"role": "user", "content": "Forklar hva et API er på én setning."}
    ],
)

print(response.choices[0].message.content)
```

---

### Samtale med flere meldinger

```python
from openai import OpenAI

client = OpenAI(
    api_key="sk-din-nøkkel-her",
    base_url="https://hackathonlite-production.up.railway.app",
)

# Bygg opp samtalehistorikk
messages = [
    {"role": "system", "content": "Du er en hjelpsom assistent for hackathon-deltakere."},
    {"role": "user",   "content": "Hva er en god måte å strukturere et Python-prosjekt?"},
]

response = client.chat.completions.create(
    model="gemini-2.0-flash",
    messages=messages,
)

svar = response.choices[0].message.content
print(svar)

# Legg til svaret i historikken for neste runde
messages.append({"role": "assistant", "content": svar})
messages.append({"role": "user", "content": "Kan du gi et konkret eksempel?"})

response2 = client.chat.completions.create(
    model="gemini-2.0-flash",
    messages=messages,
)
print(response2.choices[0].message.content)
```

---

### Streaming (tekst vises ord for ord)

```python
from openai import OpenAI

client = OpenAI(
    api_key="sk-din-nøkkel-her",
    base_url="https://hackathonlite-production.up.railway.app",
)

stream = client.chat.completions.create(
    model="gemini-2.0-flash",
    messages=[{"role": "user", "content": "Skriv et kort dikt om kode."}],
    stream=True,
)

for chunk in stream:
    tekst = chunk.choices[0].delta.content or ""
    print(tekst, end="", flush=True)
print()  # Ny linje på slutten
```

---

### Sjekke budsjett fra koden

```python
import requests

API_KEY  = "sk-din-nøkkel-her"
BASE_URL = "https://hackathonlite-production.up.railway.app"

response = requests.get(
    f"{BASE_URL}/key/info",
    params={"key": API_KEY},
    headers={"Authorization": f"Bearer {API_KEY}"},
)

data = response.json()
info = data.get("info", data)

brukt  = float(info.get("spend", 0))
maks   = float(info.get("max_budget", 30))
igjen  = maks - brukt

print(f"Brukt:  ${brukt:.4f}")
print(f"Igjen:  ${igjen:.4f}")
print(f"Budsjett: ${maks:.2f}")
```

---

## Tilgjengelige modeller

| Modell | Hastighet | Kvalitet | Anbefalt til |
|--------|-----------|----------|--------------|
| `gemini-2.0-flash` | ⚡ Raskest | Veldig god | Generell bruk, prototyping |
| `gemini-1.5-flash` | ⚡ Rask | God | Enklere oppgaver |
| `gemini-1.5-pro` | 🐢 Tregere | Best | Komplekse oppgaver |

**Tips:** Start med `gemini-2.0-flash` – den er rask og bruker lite budsjett.

---

## Sjekk forbruket ditt

Gå til **[julenissen-gh.github.io/hackathonlite](https://julenissen-gh.github.io/hackathonlite)**, lim inn nøkkelen din, og se:

- Hvor mye du har brukt
- Hvor mye du har igjen
- En fargekodet statusbar (grønn → gul → rød)

---

## Hva skjer når pengene er brukt opp?

APIet slutter automatisk å svare og returnerer en feilmelding. Du mister ikke noe arbeid – bare API-tilgangen stoppes. Ta kontakt med arrangør hvis laget trenger mer.

---

## Vanlige feil

### `401 Unauthorized`
Feil nøkkel. Sjekk at du kopierte hele `sk-...`-nøkkelen riktig.

### `429 Too Many Requests`
Du sender for mange forespørsler på kort tid. Legg inn en liten pause:
```python
import time
time.sleep(1)  # Vent 1 sekund mellom forespørsler
```

### `402 Payment Required` / budsjett-feil
Laget har brukt opp $30. Kontakt arrangør.
