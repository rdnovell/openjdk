# builder only
@ubi9/openjdk-11
@ubi9/openjdk-17
Feature: Openshift OpenJDK-only S2I tests
  Scenario: Check java perf dir owned by default (CLOUD-2070, OPENJDK-91)
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
    Then run jstat -gc 1 1000 1 in container and check its output for S0C
    And run stat --printf="%U %G" /tmp/hsperfdata_default/ in container and check its output for default root

  Scenario: Ensure Quarkus CDS doesn't fail due to timestamp mismatch (OPENDJK-1673)
    Given s2i build https://github.com/jerboaa/quarkus-quickstarts from getting-started using quickstart-2.16-s2i-cds
    Then container log should not contain A jar file is not the one used while building the shared archive file

  Scenario: quarkus fast-jar layout works out-of-the-box (OPENJDK-631)
    Given s2i build https://github.com/jmtd/openshift-quickstarts from quarkus-quickstarts/getting-started-3.0.1.Final-nos2i using OPENJDK-631-quarkus-fast-jar
    Then container log should contain INFO quarkus fast-jar package type detected
    And  container log should contain -jar /deployments/quarkus-app/quarkus-run.jar
    And  container log should contain (main) getting-started 1.0.0-SNAPSHOT on JVM (powered by Quarkus
    # these might occur if the wrong JAR is chosen as the main one
    And  container log should not contain -jar /deployments/getting-started-1.0.0-SNAPSHOT.jar
    And  container log should not contain no main manifest attribute

  Scenario: quarkus uber-jar layout works out-of-the-box (OPENJDK-631)
    Given s2i build https://github.com/jmtd/openshift-quickstarts from quarkus-quickstarts/getting-started-3.0.1.Final-nos2i with env using OPENJDK-631-quarkus-fast-jar
       | variable             | value    |
       | QUARKUS_PACKAGE_TYPE | uber-jar |
    Then container log should not contain INFO quarkus fast-jar package type detected
    And  container log should not contain -jar /deployments/quarkus-app/quarkus-run.jar
    And  container log should contain -jar /deployments/getting-started-1.0.0-SNAPSHOT-runner.jar
    And  container log should contain (main) getting-started 1.0.0-SNAPSHOT on JVM (powered by Quarkus
