# spectracker
(fastapi revision of the spectracker API server. WIP)

This is the REST API server for spectracker. A tracking app for therapy teams using the ESDM method.

## running locally

```commandline
uvicorn main:app --reload
```

### ...using docker-compose

```commandline
docker-compose down -v
docker-compose build --build-arg CURRENT_ENV=dev
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

## testing

The code is covered on a unit level by `PyTest` and on an endpoint level by `TestClient`. To run the tests, use
```commandline
poetry run pytest
```
Tests also run on each 'push' as a GitHub Actions workflow
