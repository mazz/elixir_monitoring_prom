# File: my_app/Dockerfile
FROM elixir:1.9-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nFSyXdlKCXuXTXWhnmEeVnA9VLzzbpuqX3UvpdaPo8uqpgjxd+cZorH+0GobASx8
ENV DATABASE_URL=ecto://postgres:postgres@postgres/elixir_monitoring_prom_dev

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.9 AS app

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/elixir_monitoring_prom .
# COPY --from=build /app/bin/ ./bin
COPY entrypoint.sh .
COPY start .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
# CMD ["./start"]
# CMD ["./bin/start"]
# CMD ["bash", "/app/start"]
CMD ["bash", "/app/start"]



# FROM bitwalker/alpine-elixir-phoenix:1.9.0 as releaser

# WORKDIR /app

# # Install Hex + Rebar
# RUN mix do local.hex --force, local.rebar --force

# COPY config/ /app/config/
# COPY mix.exs /app/
# COPY mix.* /app/

# # set build ENV
# ENV MIX_ENV=prod
# ENV SECRET_KEY_BASE=nFSyXdlKCXuXTXWhnmEeVnA9VLzzbpuqX3UvpdaPo8uqpgjxd+cZorH+0GobASx8
# ENV DATABASE_URL=ecto://postgres:postgres@localhost/elixir_monitoring_prom_dev


# # docker build --build-arg DATABASE_URL=ecto://postgres:postgres@localhost/registrar_dev
# RUN mix do deps.get --only $MIX_ENV, deps.compile

# COPY . /app/


# WORKDIR /app/elixir_monitoring_prom_web
# # RUN MIX_ENV=prod mix compile
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
# RUN mix phx.digest

# WORKDIR /app
# RUN MIX_ENV=prod mix release

# ########################################################################

# FROM bitwalker/alpine-elixir-phoenix:1.9.0

# EXPOSE 4000
# ENV PORT=4000 \
#     MIX_ENV=prod \
#     SHELL=/bin/bash

# WORKDIR /app
# COPY --from=releaser app/_build/prod/rel/elixir_monitoring_prom .
# COPY --from=releaser app/bin/ ./bin



### broken
# # install mix dependencies
# COPY mix.exs mix.lock ./
# COPY config config
# RUN mix deps.get --only $MIX_ENV
# RUN mix deps.compile



# COPY . /app/

# WORKDIR /app/elixir_monitoring_prom_web
# # RUN MIX_ENV=prod mix compile
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
# RUN mix phx.digest

# WORKDIR /app
# RUN MIX_ENV=prod mix release

## end broken



# build assets
# COPY assets assets
# RUN cd assets && npm install && npm run deploy
# RUN mix phx.digest

# build project
# COPY priv priv
# COPY lib lib
# RUN mix compile

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
# RUN mix release

# prepare release image
# FROM alpine:3.9 AS app

# # install runtime dependencies
# RUN apk add --update bash openssl postgresql-client

# EXPOSE 4000
# ENV MIX_ENV=prod

# # prepare app directory
# RUN mkdir /app
# WORKDIR /app

# # copy release to app container
# COPY --from=build /app/_build/prod/rel/elixir_monitoring_prom .
# COPY entrypoint.sh .
# RUN chown -R nobody: /app
# USER nobody

# ENV HOME=/app
# CMD ["bash", "/app/entrypoint.sh"]













# FROM bitwalker/alpine-elixir-phoenix:1.9.0 as releaser

# WORKDIR /app

# # Install Hex + Rebar
# RUN mix do local.hex --force, local.rebar --force

# COPY config/ /app/config/
# COPY mix.exs /app/
# COPY mix.* /app/

# COPY apps/registrar/mix.exs /app/apps/registrar/
# COPY apps/registrar_web/mix.exs /app/apps/registrar_web/

# ENV MIX_ENV=prod
# # docker build --build-arg DATABASE_URL=ecto://postgres:postgres@localhost/registrar_dev
# ENV DATABASE_URL=ecto://postgres:postgres@localhost/elixir_monitoring_prom_dev
# ENV SECRET_KEY_BASE=PV4tK6d7I3TTaygeCuaFSaZuQgmO6Lz9twMo5GSVDn4TW2+R2/ycQnzBx/20TfBt
# RUN mix do deps.get --only $MIX_ENV, deps.compile

# COPY . /app/


# WORKDIR /app/apps/registrar_web
# RUN MIX_ENV=prod mix compile
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
# RUN mix phx.digest

# WORKDIR /app
# RUN MIX_ENV=prod mix release

# ########################################################################

# FROM bitwalker/alpine-elixir-phoenix:1.9.0

# EXPOSE 4000
# ENV PORT=4000 \
#     MIX_ENV=prod \
#     SHELL=/bin/bash

# WORKDIR /app
# COPY --from=releaser app/_build/prod/rel/registrar_umbrella .
# COPY --from=releaser app/bin/ ./bin

# CMD ["./bin/start"]
