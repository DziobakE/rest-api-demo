# ===== BUILD STAGE =====
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# kopiujemy pliki potrzebne Mavenowi
COPY demo/pom.xml ./pom.xml

# pobieramy zależności (cache)
RUN mvn -q -DskipTests dependency:go-offline

# kopiujemy źródła i budujemy aplikację
COPY demo/src ./src
RUN mvn -q -DskipTests package

# ===== RUN STAGE =====
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
