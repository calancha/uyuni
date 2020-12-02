# Copyright (c) 2020 SUSE LLC
# Licensed under the terms of the MIT license.
#
# Not idempotent: after this test, the sle_client
# is upgraded to SLE 15 SP3; run this test after all
# sle_client tests.

Feature: Service pack migration for traditional client

  Scenario: Delete the traditional client for service pack migration
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Delete System"
    Then I should see a "Confirm System Profile Deletion" text
    When I click on "Delete Profile"
    And I wait until I see "has been deleted" text
    Then "sle_client" should not be registered

  Scenario: Create bootstrap script for traditional service pack migration
    When I execute mgr-bootstrap "--activation-keys=1-SUSE-SP-MIGRATION-x86_64 --script=bootstrap-spack-migration.sh --no-up2date --traditional"
    Then I should get "* bootstrap script (written):"
    And I should get "    '/srv/www/htdocs/pub/bootstrap/bootstrap-spack-migration.sh'"
    
  Scenario: Register this client for service pack migration
    Given I am authorized as "admin" with password "admin"
    When I register this client for SSH push via tunnel with "bootstrap-spack-migration.sh" script
    And I install package "spacewalk-client-setup mgr-cfg-actions" on this "sle_client"
    And I run "mgr-actions-control --enable-all" on "sle_client"
    Then I should see "sle_client" via spacecmd
    And I am on the System Overview page
    And I wait until I see the name of "sle_client", refreshing the page
    And I wait until onboarding is completed for "sle_client"

  Scenario: Migrate this traditional client to SLE 15 SP2
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Software" in the content area
    And I follow "SP Migration" in the content area
    And I wait until I see "Target Products:" text, refreshing the page
    And I click on "Select Channels"
    And I wait until I see "SUSE Linux Enterprise Server 15 SP2 x86_64" text
    And I click on "Schedule Migration"
    And I should see a "Service Pack Migration - Confirm" text
    And I click on "Confirm"
    And I run "rhn_check -vvv" on "sle_client"
    Then I should see a "This system is scheduled to be migrated to" text

  Scenario: Check the migration status for this traditional client
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Events"
    And I follow "History"
    And I wait at most 600 seconds until event "Service Pack Migration scheduled by admin" is completed

  Scenario: Check the migration is successful for this traditional client
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Details" in the content area
    Then I should see a "SUSE Linux Enterprise Server 15 SP2" text

  Scenario: Cleanup: delete the migrated traditional client
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Delete System"
    Then I should see a "Confirm System Profile Deletion" text
    When I click on "Delete Profile"
    And I wait until I see "has been deleted" text
    Then "sle_client" should not be registered

  Scenario: Cleanup: hosts file of traditional client via SSH tunnel
    Given I am on the Systems page
    And I run "sed -i '/127.0.1.1/d' /etc/hosts" on "sle_client"
    And I run "rm /srv/www/htdocs/pub/bootstrap/bootstrap-spack-migration.sh" on "server"
    And I remove server hostname from hosts file on "sle_client"

  Scenario: Cleanup: register a traditional client after service pack migration
    When I bootstrap traditional client "sle_client" using bootstrap script with activation key "1-SUSE-DEV-x86_64" from the proxy
    Then I should see "sle_client" via spacecmd
