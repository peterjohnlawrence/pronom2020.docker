# pronom2020.docker
Docker build for pronom2020

To make this a self standing build of pronom2020 docker image the following WARs are required:
* report2odata.war : XML file generation engine, dependent og droid-core
* pronom2020.war : Documentation 
* odata2sparql.v4.war : OData RESTFul service
* lens2odata.war : Primary webapp
