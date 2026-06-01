# CLAUDE.md

> [!IMPORTANT]
> **Do only what I ask and nothing more**. Do not add any extra code, comments, or anything
> else that I didn't explicitly request. Do not be proactive, do not anticipate my needs,
> and do not make any assumptions.

## Environment

Development happens inside a Nix flake development shell, loaded automatically via direnv.

- To format code, run `nix fmt`. Flake has treefmt set-up to format all code in the repository.
- For code analysis, use `mix credo --strict` and `mix dialyzer`.

## Committing

Before committing, ALWAYS run and ensure these pass:

1. `nix fmt`
2. `mix credo --strict`
3. `mix dialyzer`
4. `mix test`

In every commit you make, instead of using `Co-Authored-By`, you MUST use a convention similar to
the [kernel convention](https://docs.kernel.org/process/coding-assistants.html#attribution):

```text
Assisted-by: AGENT_NAME:MODEL_VERSION
```

- Replace `AGENT_NAME` with the used AI tool or framework, e.g. "Claude".
- Replace `MODEL_VERSION` with the actual model in use, e.g. `claude-opus-4.8`

## Projects

### soulseek (`apps/soulseek`)

This library is an implementation of the Soulseek protocol. It implements messages,
constants, framing, and other protocol-level details.

> [!IMPORTANT]
>
> 1. Before implementing, changing, or reviewing **ANYTHING** (messages, codes, constants, wire
> protocol, framing), **read the relevant sections of the provided documentation first**.
> Do not make guesses.
>
> 2. The protocol is reverse-engineered and thus may/will contain inconsistencies, errors, or
> missing details. If two sources disagree or contradict each other, **surface it** rather
> than being silent about it. Prefer Nicotine+ protocol document over the others, as it's
> from the most popular Soulseek client.

#### Protocol References

1. `apps/soulseek/doc/protocol/Nicotine+ SLSKPROTOCOL.md`
2. `apps/soulseek/doc/protocol/aioslsk SOULSEEK.rst`

### soulsex (`apps/soulsex`)

This is an OTP application that implements a Soulseek server using `soulseek`.
