FROM webgames/awscli-java8

EXPOSE 9083

RUN cd /opt \
        && wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz  \
        && tar -xzf hadoop-2.7.3.tar.gz \
        && ln -s hadoop-2.7.3 hadoop \
        && rm -f hadoop-2.7.3.tar.gz


RUN cd /opt \
        && wget https://archive.apache.org/dist/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz \
        && tar -xzf apache-hive-2.3.9-bin.tar.gz \
        && ln -s apache-hive-2.3.9-bin hive \
        && rm -f apache-hive-2.3.9-bin.tar.gz \
        && wget https://repo.maven.apache.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar -O /opt/hive/lib/hadoop-aws-2.7.3.jar

ENV HADOOP_HOME /opt/hadoop

RUN wget https://repo.maven.apache.org/maven2/mysql/mysql-connector-java/5.1.40/mysql-connector-java-5.1.40.jar -O /opt/hive/lib/mysql-connector-java-5.1.40.jar \
	&& aws s3 cp s3://webgames-app-distr/hivemetastore/HiveGlueCatalogSyncAgent-1.2-SNAPSHOT-complete.jar /opt/hive/lib/ \
	&& wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.12.43/aws-java-sdk-core-1.12.43.jar -O /opt/hive/lib/aws-java-sdk-core-1.12.43.jar \
	&& wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-logs/1.12.43/aws-java-sdk-logs-1.12.43.jar -O /opt/hive/lib/aws-java-sdk-logs-1.12.43.jar 

ENV HADOOP_OPTS="-Dhive.log.level=DEBUG"

CMD aws s3 cp $HIVE_SITE_XML_S3_PATH /opt/hive/conf/ && aws s3 cp $CORE_SITE_XML_S3_PATH /opt/hadoop/etc/hadoop/ && /opt/hive/bin/hive --service metastore
