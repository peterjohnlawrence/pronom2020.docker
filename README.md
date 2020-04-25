# pronom2020.docker
Docker build for pronom2020

To make this a self standing build of pronom2020 docker image the following WARs are required:
* report2odata.war : XML file generation engine, dependent on droid-core, [https://github.com/peterjohnlawrence/com.inova8.report2odata]
* pronom2020.war : Documentation  [https://github.com/peterjohnlawrence/pronom2020.documentation]
* odata2sparql.v4.war : OData RESTFul service [https://github.com/peterjohnlawrence/com.inova8.odata2sparql.v4]
* lens2odata.war : Primary webapp [https://github.com/peterjohnlawrence/com.inova8.lens.framework.v4]
