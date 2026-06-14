# CLAUDE.md

> [!IMPORTANT]
> **Do only what I ask and nothing more**. Do not add any extra code, comments, or anything
> else that I didn't explicitly request. Do not be proactive, do not anticipate my needs,
> and do not make any assumptions.

## Environment

Development happens inside a Nix flake development shell, loaded automatically via `direnv`.

- To format code, run `nix fmt`. Flake has `treefmt-nix` set-up to format all code in the repository.
- For code analysis, use `mix credo --strict` and `mix dialyzer`.

> [!TIP]
> You can use `nix fmt [files]` for formatting specific files, instead of the whole repository
> or doing `mix format` for Elixir files.

## Committing

Before committing, ALWAYS run and ensure these pass:

1. `mix test`
2. `mix credo --strict`
3. `mix dialyzer`
4. `nix fmt`

In every commit you make, instead of using `Co-Authored-By`, you MUST use a convention similar to
the [kernel convention](https://docs.kernel.org/process/coding-assistants.html#attribution):

```text
Assisted-by: AGENT_NAME:MODEL_VERSION
```

- Replace `AGENT_NAME` with the used AI tool or framework, e.g. "Claude Code", "opencode".
- Replace `MODEL_VERSION` with the actual model in use, e.g. `claude-opus-4.8`, `deepseek-v4-flash`, `gemini-3.5-flash`.

## Projects

### soulseek (`lib/soulseek`)

This library is an implementation of the Soulseek protocol. It implements messages,
constants, framing, and other protocol-level details.

> [!IMPORTANT]
>
> - Before implementing, changing, or reviewing **ANYTHING** (messages, codes, constants, wire
> protocol, framing), **read the relevant sections of the provided documentation first**.
> Do not make guesses.
>
> - The protocol is reverse-engineered and thus may/will contain inconsistencies, errors, or
> missing details. If two sources disagree or contradict each other, **surface it** rather
> than being silent about it. Prefer Nicotine+ protocol document over the others, as it's
> from the most popular Soulseek client, but this shouldn't mean you ignore contradictions
> or missing details in it. If you find any, document them in the code and let the reviewer
> know about them.

#### Protocol References

1. [Nicotine+ Protocol Documentation](https://nicotine-plus.org/doc/SLSKPROTOCOL.html)
2. [Soulseek.NET Protocol Documentation](https://github.com/jpdillingham/Soulseek.NET/blob/master/docs/Soulseek%20Protocol%20Documentation.html)
3. [Museek+ Protocol Documentation](https://web.archive.org/web/20220327151706/https://www.museek-plus.org/wiki/SoulseekProtocol)
4. [aioslsk Soulseek Protocol](https://aioslsk.readthedocs.io/en/latest/SOULSEEK.html)
5. [aioslsk Soulseek MESSAGES](https://aioslsk.readthedocs.io/en/latest/MESSAGES.html)

### soulsex (`lib/soulsex`)

This is an OTP application that implements a Soulseek server using `soulseek`.
