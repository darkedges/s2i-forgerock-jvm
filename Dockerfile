ARG JVM_IMAGE=eclipse-temurin
ARG JVM_TAG=11.0.14_9-jre-alpine

FROM busybox
ARG NAMESPACE=forgerock

RUN wget --no-check-certificate -O /tmp/${NAMESPACE}_idam_intermediate.pem https://vault.internal.darkedges.com/v1/${NAMESPACE}_idam_intermediate/ca/pem && \
    wget --no-check-certificate -O /tmp/${NAMESPACE}_idam_root.pem https://vault.internal.darkedges.com/v1/${NAMESPACE}_idam_root/ca/pem 

FROM ${JVM_IMAGE}:${JVM_TAG} as JRE

FROM darkedges/s2i-alpine-base:3.17.2
ARG NAMESPACE=forgerock

COPY --from=0 /tmp/* /usr/local/share/ca-certificates/
COPY --from=JRE /opt/java/openjdk /opt/java/openjdk

ENV JAVA_HOME=/opt/java/openjdk \
    JAVA_VERSION=jdk-11.0.14+9 \
    PATH=$PATH:/opt/java/openjdk/bin

RUN update-ca-certificates && \
    cp /usr/local/share/ca-certificates/* /etc/ssl/certs && \
    update-ca-certificates && \
    keytool -import -trustcacerts -noprompt -cacerts -file /usr/local/share/ca-certificates/${NAMESPACE}_idam_root.pem -storepass changeit -alias ${NAMESPACE}Root && \
    keytool -import -trustcacerts -noprompt -cacerts -file /usr/local/share/ca-certificates/${NAMESPACE}_idam_intermediate.pem -storepass changeit -alias ${NAMESPACE}Intermediate && \
    rm -rf /var/cache/apk/*