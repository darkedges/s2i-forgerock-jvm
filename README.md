# s2i-forgerock-jvm

## JRE

```bash
docker build . -t darkedges/s2i-forgerock-jvm:11.0.18_10-jre-alpine
```

## JVM

```bash
docker build . --build-arg JVM_TAG=11.0.18_10-jdk-alpine -t darkedges/s2i-forgerock-jvm:11.0.18_10-jdk-alpine
```
