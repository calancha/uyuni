# Copyright (c) 2020 SUSE LLC
# Licensed under the terms of the MIT license.
#
# Not idempotent: after this test, the sle_client
# is upgraded to SLE 15 SP3; run this test after all
# sle_client tests.

Feature: Service pack migration

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
    When I register this client for SSH push via tunnel with "bootstrap-spack-migration.sh" script
    And I install package "spacewalk-client-setup spacewalk-oscap mgr-cfg-actions" on this "sle_client"
    And I run "mgr-actions-control --enable-all" on "sle_client"
    Then I should see "sle_ssh_tunnel_client" via spacecmd

  Scenario: Migrate this traditional client to SLE 15 SP2
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Software" in the content area
    And I follow "SP Migration" in the content area
    And I should see a "Service Pack Migration - Target" text
    And I click on "Select Channels"
    And I wait until I see "SUSE Linux Enterprise Server 15 SP2 x86_64" text
    And I click on "Schedule Migration"
    And I should see a "Service Pack Migration - Confirm" text
    And I click on "Confirm"
    Then I should see a "This system is scheduled to be migrated to" text

  Scenario: Check the migration status
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Events"
    And I follow "History"
    And I wait at most 600 seconds until event "Package List Refresh scheduled by admin" is completed

  Scenario: Check the migration is successful
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Details" in the content area
    Then I should see a "SUSE Linux Enterprise Server 15 SP2" text
