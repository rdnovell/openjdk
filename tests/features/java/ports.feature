@ubi9/openjdk-11
@ubi9/openjdk-17
Feature: Openshift OpenJDK port tests

  Scenario: Check ports are available
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
    Then check that port 8080 is open
    Then check that port 8443 is open
    Then inspect container
       | path                    | value       |
       | /Config/ExposedPorts    | 8080/tcp    |
       | /Config/ExposedPorts    | 8443/tcp    |
