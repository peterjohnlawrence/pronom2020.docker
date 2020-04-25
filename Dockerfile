# Build based on Tomcat
FROM tomcat:9-jre8
LABEL pronom2020:latest inova8/pronom2020:latest
LABEL version="2.0"
LABEL maintainer = "peter.lawrence@inova8.com"
LABEL description = "Pronom2020 RDF4J 3.0.0 + Odata2SPARQL + Lens2OData + report2odata bundled into a single container"

# Setup variables
ARG RDF4J_VERSION="3.1.3" 
ENV RDF4J_DATA="/opt/eclipse-rdf4j-${RDF4J_VERSION}/data" 
ARG JVM_PARAMS="-Xmx4g" 
#ENV ODATA4SPARQL ="C:/Users/Peter/git/com.inova8.odata2sparql.v4/odata2sparql.v4/target/"
#ENV FRAMEWORK ="C:/Apps/SAPWebIDE/serverworkspace/pe/peterlawrence1/OrionContent/com.inova8.lens.framework.v4/target/"
#ENV SERVER ="C:/Users/Peter/AppData/Roaming/rdf4j/data/server"
ENV MODELS="/var/opt/inova8/odata2sparql/.default" 
ENV INOVA8="/usr/local/tomcat/inova8" 

# Install the lastest RDF4J server and workbench
RUN curl -sS -o /tmp/rdf4j.zip -L http://download.eclipse.org/rdf4j/eclipse-rdf4j-${RDF4J_VERSION}-sdk.zip && \
    cd /opt && \ 
    unzip /tmp/rdf4j.zip && \
    rm /tmp/rdf4j.zip
RUN mv /opt/eclipse-rdf4j-${RDF4J_VERSION}/war/*.war /usr/local/tomcat/webapps
#RUN jar -uvf /opt/eclipse-rdf4j-${RDF4J_VERSION}/war/rdf4j-workbench.war  transformations/create.xsl 
RUN echo "CATALINA_OPTS=\"\$CATALINA_OPTS \$JVM_PARAMS -Dorg.eclipse.rdf4j.appdata.basedir=\$RDF4J_DATA\"" >> /usr/local/tomcat/bin/setenv.sh

# Configure Tomcat users
ADD  tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
ADD  context.xml  /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Install odata2sparql and its configuration file (models.ttl)
ADD [ "odata2sparql.v4.war",  "/usr/local/tomcat/webapps/odata2sparql.war"]
ADD  models.ttl /var/opt/inova8/odata2sparql/.default/

# Install report2odata 
ADD [ "report2odata.war",  "/usr/local/tomcat/webapps/report2odata.war"]

# Install pronom2020 documentation site 
ADD [ "pronom2020.war",  "/usr/local/tomcat/webapps/pronom2020.war"]

# Install lens framwork, its prepared repositories, and preinitialized user preferences
# NOTE that since the odata4sparql is now on a different server than the app is running,  it should be redirected in the <apartment>/manifest.json.
# For example "sap.app": {	"dataSources": {"dataService": "uri": "http://localhost:8080/odata2sparql/northwind/" -> "http://localhost:<Port of Docker container>/odata2sparql/northwind/"
ADD  ["com.inova8.lens.framework.v4.war", "/usr/local/tomcat/webapps/lens2odata.war"] 
ADD  server $RDF4J_DATA/server
ADD  inova8 $INOVA8

# Copy model files for consistency and rebuilding if required.
ADD  server ${RDF4J_DATA}/server

# Publish RDF4J data volumes
VOLUME ${RDF4J_DATA}
VOLUME ${MODELS}
VOLUME ${INOVA8}

EXPOSE 8080

LABEL pronom2020:latest inova8/pronom2020:latest