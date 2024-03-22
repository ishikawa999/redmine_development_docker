ARG RUBY_VERSION
# tag list https://mcr.microsoft.com/v2/vscode/devcontainers/ruby/tags/list
FROM mcr.microsoft.com/vscode/devcontainers/ruby:$RUBY_VERSION
ARG APP_HOME
ARG APP_PORT
ENV LANG C.UTF-8

ENV DEBIAN_FRONTEND noninteractive
RUN set -eux; \
  apt update && \
  apt install -y --no-install-recommends \
    bzr git mercurial subversion \
    gsfonts \
    imagemagick libmagick++-dev \
    build-essential libpq-dev libclang-dev \
    vim less locales locales-all \
    default-libmysqlclient-dev libsqlite3-dev \
    ; \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt install -y nodejs && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*;
ENV DEBIAN_FRONTEND dialog

WORKDIR $APP_HOME
ADD ./app/. $APP_HOME

COPY ./scripts/. /
RUN for file_name in "/start.sh /entrypoint.sh /setup.sh /custom_shell.sh"; do \
      chmod +x $file_name; \
    done

RUN bundle update
RUN bundle install
RUN gem install ruby-lsp && gem install ruby-lsp-rails
RUN /setup.sh

EXPOSE $APP_PORT

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start.sh"]
