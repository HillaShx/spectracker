# syntax=docker/dockerfile:1

FROM python:3.9-alpine3.13

ARG CURRENT_ENV

ENV CURRENT_ENV=${CURRENT_ENV} \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VERSION=1.1.11 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN echo Container is running in $CURRENT_ENV mode

RUN pip install docker-compose
RUN apk add --no-cache python3-dev gcc libc-dev musl-dev openblas gfortran build-base postgresql-libs postgresql-dev libffi-dev curl rust cargo

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
ENV PATH "/root/.local/bin:$PATH"


# install dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry install $(test "$CURRENT_ENV" == prod && echo "--no-dev") --no-interaction --no-ansi

COPY . .
