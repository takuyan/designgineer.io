# HTTPS migration runbook (designgineer.io)

This runbook migrates `designgineer.io` from S3 website-only delivery to `S3 + CloudFront + ACM` with HTTPS.

## 0. Scope and assumptions

- Static files are built by Middleman and uploaded to S3.
- Existing bucket: `designgineer.io`
- Target canonical URL: `https://designgineer.io`
- Optional redirect: `https://www.designgineer.io` -> `https://designgineer.io`

## 1. Request ACM certificate (us-east-1)

CloudFront requires the certificate in `us-east-1`.

1. Open ACM in `us-east-1`.
2. Request a public certificate for:
- `designgineer.io`
- `www.designgineer.io`
3. Validate by DNS (recommended).
4. Wait until status is `Issued`.

## 2. Create CloudFront distribution

1. Create a standard distribution.
2. Origin:
- Use S3 bucket `designgineer.io`.
- Prefer the S3 REST endpoint + OAC (Origin Access Control).
3. Default root object: `index.html`.
4. Alternate domain names (CNAME):
- `designgineer.io`
- `www.designgineer.io`
5. Attach the ACM certificate issued in `us-east-1`.
6. Viewer protocol policy:
- `Redirect HTTP to HTTPS`
7. Optional but recommended:
- Compression: on
- IPv6: on

## 3. Configure DNS

If Route53 is used:

1. Create/Update apex record:
- Name: `designgineer.io`
- Type: `A` Alias -> CloudFront distribution
2. Create/Update `www` record:
- Name: `www.designgineer.io`
- Type: `A` Alias -> same CloudFront distribution

If another DNS provider is used:

- Use `ALIAS/ANAME` if available for apex.
- Otherwise, follow provider guidance for apex-to-CloudFront mapping.

## 4. Optional canonical redirect (www -> apex)

If you want host canonicalization, publish this CloudFront Function:

- File: `infrastructure/cloudfront/viewer-request-redirect.js`
- Trigger: `Viewer Request` on default behavior.

This keeps URL host canonical while CloudFront handles HTTP->HTTPS redirect at behavior level.

## 5. Verification checklist

After distribution status is `Deployed` and DNS has propagated:

```bash
curl -I http://designgineer.io
curl -I https://designgineer.io
curl -I https://www.designgineer.io
```

Expected:

- `http://designgineer.io` returns redirect to `https://designgineer.io/...`
- `https://designgineer.io` returns `200`
- `https://www.designgineer.io` returns `301` to apex (if function enabled)

Browser checks:

- No certificate warning
- No mixed-content warning in DevTools

## 6. Rollback plan

If unexpected issues occur:

1. Revert DNS records from CloudFront alias to previous endpoint.
2. Disable CloudFront Function if redirects are looping.
3. Invalidate CloudFront cache (`/*`) after config correction.

## 7. Notes for this repository

- Site links and external refs are already HTTPS-friendly.
- Deploy command remains:

```bash
BUNDLE_WITH=deploy bundle exec middleman s3_sync
```

CloudFront serves and secures the uploaded S3 assets.
