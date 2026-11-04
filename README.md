# spacegho.st/tools

The site at **https://spacegho.st/tools/**: one page per tool, served as
static files by a Cloudflare Worker that runs no script. Every route on the
zone except `/tools` is left untouched.

| tool | page | source |
|---|---|---|
| romsort | [spacegho.st/tools/romsort/](https://spacegho.st/tools/romsort/) | [Spaceghost/romsort](https://github.com/Spaceghost/romsort) |

Every tool repository is tagged with the GitHub topic
[`spacegho-st-tools`](https://github.com/topics/spacegho-st-tools).

## Adding a tool

1. Tag its repository with `spacegho-st-tools` and set the homepage to
   `https://spacegho.st/tools/<name>/`.
2. Add `public/tools/<name>/index.html`, linking `/tools/tools.css`, with no
   inline script or style (the CSP in `public/_headers` forbids both).
3. Add its card to `public/tools/index.html` and its row to the table above.
4. Run `scripts/check.sh`, commit and push to `master`. The deploy publishes it.

## Deploying

`.github/workflows/deploy.yml` runs `wrangler deploy` on every push to
`master` that touches `public/` or `wrangler.toml`. It needs, in the
repository's `cloudflare` environment:

```sh
gh variable set CLOUDFLARE_ACCOUNT_ID --env cloudflare -R Spaceghost/tools --body <account id>
gh secret set CLOUDFLARE_API_TOKEN --env cloudflare -R Spaceghost/tools   # Workers Scripts + Routes: Edit
```

Preview locally with `npx wrangler dev` and open http://localhost:8787/tools/.
