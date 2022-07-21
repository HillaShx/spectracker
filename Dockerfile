# syntax=docker/dockerfile:1

FROM python:3.9-alpine3.13

ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VERSION=1.1.11 \
    YOUR_ENV=development \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN pip install docker-compose
RUN apk add --no-cache python3-dev gcc libc-dev musl-dev openblas gfortran build-base postgresql-libs postgresql-dev libffi-dev curl rust cargo

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
ENV PATH "/root/.local/bin:$PATH"


# install dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi

COPY . .
