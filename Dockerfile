FROM python:3.11-alpine as base

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.6.1

RUN apk add --no-cache gcc libffi-dev musl-dev
RUN pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock ./

RUN poetry export -f requirements.txt | /venv/bin/pip install -r /dev/stdin

COPY dist dist
RUN /venv/bin/pip install dist/*.whl

FROM base as final
LABEL org.opencontainers.image.source=https://github.com/eirik-talberg/python-demoapp
LABEL org.opencontainers.image.description="Python demoapp with semantic-release"
LABEL org.opencontainers.image.licenses=MIT

COPY --from=builder /venv /venv
COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
