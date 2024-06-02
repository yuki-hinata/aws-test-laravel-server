# ベースイメージとしてPHPを使用
# ?→ここのベースイメージは何を選ぶべきか
FROM php:8.3.0-apache

# 作業ディレクトリを設定
# ?→ここの作業ディレクトリってある程度「ここでやるべき！」みたいなのはあるのか？
WORKDIR /var/www/html

# システムパッケージの更新と依存関係のインストール
# ?→ここのパッケージは何をインストールすべきか？
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# アプリケーションソースコードをコピー
COPY . .

# Composerの依存関係をインストール
RUN composer install

# ストレージディレクトリとキャッシュディレクトリの権限を設定
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# デフォルトのCMDをPHPビルトインサーバーに設定
# ?→ここって本来はビルトインサーバーではなく、php-fpmなどを立てるべき
CMD php -S 0.0.0.0:8000 -t public
