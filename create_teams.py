"""
Kjør dette scriptet etter at LiteLLM-serveren er oppe for å opprette API-nøkler til hvert lag.
Resultatene lagres i team_keys.json og skrives ut til terminalen.

Bruk: python create_teams.py
"""

import requests
import json
import os
import sys

BASE_URL = os.getenv("LITELLM_URL", "http://localhost:4000")
MASTER_KEY = os.getenv("LITELLM_MASTER_KEY", "")
BUDGET_PER_TEAM = 30.0  # USD


def create_key(team_name: str, team_alias: str) -> dict:
    response = requests.post(
        f"{BASE_URL}/key/generate",
        headers={
            "Authorization": f"Bearer {MASTER_KEY}",
            "Content-Type": "application/json",
        },
        json={
            "max_budget": BUDGET_PER_TEAM,
            "key_alias": team_alias,
            "metadata": {"team": team_name},
            "models": ["gemini-2.0-flash", "gemini-1.5-flash", "gemini-1.5-pro"],
        },
    )
    response.raise_for_status()
    return response.json()


def main():
    if not MASTER_KEY:
        print("Feil: Sett LITELLM_MASTER_KEY som miljøvariabel")
        print("  Windows: set LITELLM_MASTER_KEY=din-nøkkel")
        print("  Linux/Mac: export LITELLM_MASTER_KEY=din-nøkkel")
        sys.exit(1)

    # Definer lagnavn her (endre til dine faktiske lagnavn)
    teams = [
        "Lag 1",
        "Lag 2",
        "Lag 3",
        "Lag 4",
        "Lag 5",
        "Lag 6",
        "Lag 7",
        "Lag 8",
        "Lag 9",
        "Lag 10",
    ]

    print(f"Oppretter {len(teams)} API-nøkler med ${BUDGET_PER_TEAM} budsjett hver...")
    print(f"Kobler til: {BASE_URL}\n")

    results = []
    for team in teams:
        alias = team.lower().replace(" ", "-")
        try:
            data = create_key(team, alias)
            entry = {
                "team": team,
                "key": data["key"],
                "max_budget": BUDGET_PER_TEAM,
            }
            results.append(entry)
            print(f"✓ {team}: {data['key']}")
        except requests.HTTPError as e:
            print(f"✗ {team}: Feil - {e.response.text}")
        except requests.ConnectionError:
            print(f"✗ Kan ikke koble til {BASE_URL}. Er serveren oppe?")
            sys.exit(1)

    # Lagre til fil
    output_file = "team_keys.json"
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)

    print(f"\nNøkler lagret til {output_file}")
    print("\n--- Del dette med lagene ---")
    print(f"API Base URL: {BASE_URL}")
    print("Modeller tilgjengelig: gemini-2.0-flash, gemini-1.5-flash, gemini-1.5-pro")
    print(f"Budsjett per lag: ${BUDGET_PER_TEAM}")
    print("Sjekk forbruk: åpne dashboard-siden og skriv inn API-nøkkelen din")


if __name__ == "__main__":
    main()
