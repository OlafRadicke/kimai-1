FROM ubuntu:latest
MAINTAINER mwaeckerlin

ENV KIMAI_LINK http://downloads.sourceforge.net/project/kimai/0.9.x/kimai.0.9.2.1306-3.zip
ENV KIMAI_ROOT /var/www/kimai
ENV KIMAI_NEED_WRITE ${KIMAI_ROOT}
#/{compile,extensions/ki_timesheets/compile,extensions/ki_adminpanel/compile,extensions/ki_expenses/compile,extensions/ki_export/compile,extensions/ki_budget/compile,extensions/ki_invoice/compile,temporary,includes/autoconf.php}

WORKDIR /tmp
RUN apt-get update -y
RUN apt-get install -y wget unzip nginx php5-fpm php5-mysql mysql-client pwgen nmap
RUN wget -qO /tmp/kimai.zip "${KIMAI_LINK}"
RUN unzip /tmp/kimai.zip -d /var/www/
RUN mkdir -p ${KIMAI_NEED_WRITE} || true
RUN chown -R www-data.www-data ${KIMAI_NEED_WRITE}
RUN rm /etc/nginx/sites-available/* /etc/nginx/sites-enabled/*
ADD kimai.conf /etc/nginx/sites-available/kimai.conf
RUN ln -s /etc/nginx/sites-available/kimai.conf /etc/nginx/sites-enabled/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80
VOLUME /etc/kimai
ADD start.sh /start.sh
CMD /start.sh