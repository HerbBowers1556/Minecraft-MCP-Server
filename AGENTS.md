# Repository Guidelines

## Project Structure & Module Organization

- `mcp_server/server.py` exposes the FastMCP `run_command` tool and sends commands through RCON.
- `mcp_server/mcp_chat_client.py` monitors Minecraft logs for `@ai` messages, queries Gemini, and invokes MCP tools.
- `mcp_server/commands.json` contains command descriptions and examples; `chat_history.json` stores player conversations.
- `requirements.txt` pins dependencies. `.github/workflows/python-app.yml` defines CI. No test directory or separate asset directory currently exists.

## Build, Test, and Development Commands

Use Python 3.10 to match CI. Run setup commands from the repository root:

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m pip install flake8 pytest
```

There is no compilation step. Run scripts from `mcp_server/` so relative JSON paths resolve:

```powershell
cd mcp_server
python server.py
python mcp_chat_client.py
```

These are separate entry points: the chat client launches its own stdio server subprocess. Set `MCP_SERVER_PATH` to an absolute `server.py` path.

From the repository root, run CI checks:

```powershell
python -m flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
python -m flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
python -m pytest
```

The second lint pass reports warnings without failing.

## Coding Style & Naming Conventions

Use four-space indentation, `snake_case` functions and variables, `PascalCase` classes, and `UPPER_CASE` constants. Follow existing type hints and async patterns. Keep changes procedural and focused; extend existing methods before introducing abstractions. Do not add classes, properties, or enums without explicit direction. Never swallow exceptions; catch only when meaningful recovery or reporting is possible. Flake8 is configured through CI; no formatter is configured.

## Testing Guidelines

CI uses pytest; no tests or coverage threshold currently exist. Add focused regression tests under `tests/test_*.py`, with `test_*` functions. Mock RCON, Gemini, and filesystem inputs for automated checks. For integration checks, use a disposable Minecraft server and invoke `run_command` with `/list`.

## Commit & Pull Request Guidelines

History mixes `feat:` and `fix:` prefixes with plain imperative summaries. Prefer concise, scoped messages such as `fix: handle missing log files`. Describe behavior changes, link relevant issues, and record validation commands and results in pull requests. Include configuration changes when applicable.

## Security & Configuration

Keep `.env` files and API keys untracked. Configure `MINECRAFT_LOG_PATH`, `MCP_SERVER_PATH`, and `GEMINI_API_KEY` locally. RCON settings currently live in `server.py`; never commit real credentials. Exclude private player conversations from commits. Treat generated commands as privileged operations; prompt restrictions alone do not enforce authorization.
