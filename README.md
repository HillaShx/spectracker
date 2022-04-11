# spectracker
(fastapi revision of the spectracker API server)

This is the REST API server for spectracker. A tracking app for therapy teams using the ESDM method.

## running locally

```commandline
uvicorn main:app --reload
```

## testing

The code is covered on a unit level by `PyTest` and on an endpoint level by `TestClient`. To run the tests, use
```commandline
poetry run pytest
```
Tests also run on each commit using a pre-commit hook
