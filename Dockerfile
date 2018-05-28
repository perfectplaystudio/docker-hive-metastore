FROM webgames/awscli-java8

EXPOSE 9083

RUN cd /opt \
        && wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz  \
        && tar -xzf hadoop-2.7.3.tar.gz \
        && ln -s hadoop-2.7.3 hadoop \
        && rm -f hadoop-2.7.3.tar.gz


RUN cd /opt \
        && wget http://ftp.cixug.es/apache/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz \
        && tar -xzf apache-hive-2.1.1-bin.tar.gz \
        && ln -s apache-hive-2.1.1-bin hive \
        && rm -f apache-hive-2.1.1-bin.tar.gz

ENV HADOOP_HOME /opt/hadoop

RUN wget http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.40/mysql-connector-java-5.1.40.jar -O /opt/hive/lib/mysql-connector-java-5.1.40.jar

CMD aws s3 cp $HIVE_SITE_XML_S3_PATH /opt/hive/conf/ && /opt/hive/bin/hive --service metastore --hiveconf hive.root.logger=WARN
