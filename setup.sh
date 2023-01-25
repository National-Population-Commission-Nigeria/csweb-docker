# Script to setup csweb

echo "<?php \
    define('DBHOST', '$MYSQL_HOST'); \
    define('DBUSER', '$MYSQL_USER'); \
    define('DBPASS', '$MYSQL_PASSWORD'); \
    define('DBNAME', '$MYSQL_DATABASE'); \
    define('ENABLE_OAUTH', true); \
    define('FILES_FOLDER', '/var/www/html/files'); \
    define('DEFAULT_TIMEZONE', 'UTC'); \
    define('MAX_EXECUTION_TIME', '300'); \
    define('API_URL', 'http://localhost/api/'); \
    define('CSWEB_LOG_LEVEL' , 'error'); \
    define('CSWEB_PROCESS_CASES_LOG_LEVEL', 'error'); \
    ?>" > /var/www/html/src/AppBundle/config.php
