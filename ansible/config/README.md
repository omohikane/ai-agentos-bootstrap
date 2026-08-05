# ansible/config/

Per-AI-agent dotfile templates.

The `ai` role (M3) generates `~/.config/<tool>/` files from
`ansible/config/<tool>/` Jinja2 templates. Master settings are kept in this
repository and rendered per agent.

## Planned

```
config/
├── opencode/
│   └── opencode.conf.j2     … opencode configuration
├── goose/
│   └── ...
└── codex/
    └── ...
```

To add a tool: add it to `ansible/vars/ai-tools.list` and provide a renderable
template under `ansible/config/<tool>/`.