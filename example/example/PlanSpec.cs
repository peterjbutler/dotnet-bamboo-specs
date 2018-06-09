using com.atlassian.bamboo.specs.api.builders;
using com.atlassian.bamboo.specs.api.builders.permission;
using com.atlassian.bamboo.specs.api.builders.plan;
using com.atlassian.bamboo.specs.api.builders.plan.branches;
using com.atlassian.bamboo.specs.api.builders.plan.configuration;
using com.atlassian.bamboo.specs.api.builders.project;
using com.atlassian.bamboo.specs.builders.task;
using com.atlassian.bamboo.specs.builders.trigger;
using com.atlassian.bamboo.specs.model.task;
using com.atlassian.bamboo.specs.util;

namespace DotNetBambooSpecs.Example
{
    public class PlanSpec
    {
        public Plan Plan()
        {
            Plan plan = new Plan(new Project()
                    .key(new BambooKey("DBS"))
                    .name("DotnetBambooSpecs")
                    .description("DotnetBambooSpecs"),
                "SampleBuild",
                new BambooKey("SB"))
                .pluginConfigurations(new ConcurrentBuilds()
                        .useSystemWideDefault(false),
                    new AllOtherPluginsConfiguration()
                        .configuration(new MapBuilder()
                                .put("custom.buildExpiryConfig.enabled", "false")
                                .build()))
                .stages(new Stage("Default Stage")
                        .jobs(new Job("Default Job",
                                new BambooKey("JOB1"))
                                .pluginConfigurations(new AllOtherPluginsConfiguration()
                                        .configuration(new MapBuilder()
                                                .put("custom", new MapBuilder()
                                                    .put("auto", new MapBuilder()
                                                        .put("regex", "")
                                                        .put("label", "")
                                                        .build())
                                                    .put("buildHangingConfig.enabled", "false")
                                                    .put("ncover.path", "")
                                                    .put("clover", new MapBuilder()
                                                        .put("path", "")
                                                        .put("license", "")
                                                        .put("useLocalLicenseKey", "true")
                                                        .build())
                                                    .build())
                                                .build()))
                                .tasks(new VcsCheckoutTask()
                                        .checkoutItems(new CheckoutItem().defaultRepository())
                                        .cleanCheckout(true)
                                        .description("Checkout Default Repository"),
                                    new CommandTask()
                                        .executable("Nuget")
                                        .argument("restore")
                                        .description("Nuget Restore"),
                                    new MsBuildTask()
                                        .executable("MSBuild v15 (64bit)")
                                        .projectFile("DotnetBambooSpecs.SampleBuild.sln")
                                        .workingSubdirectory("")
                                        .description("MSBuild"),
                                    new NUnitRunnerTask()
                                        .executable("NUnit v3")
                                        .nUnitVersion3()
                                        .nUnitTestFiles("UnitTests\\bin\\Debug\\DotnetBambooSpecs.SampleBuild.UnitTests.dll")
                                        .resultFilename("TestResult.xml")
                                        .testsToRun("")
                                        .testCategoriesToInclude("")
                                        .testCategoriesToExclude("")
                                        .description("NUnit Runner"),
                                    new TestParserTask(TestParserTaskProperties.TestType.NUNIT)
                                        .resultDirectories("TestResult.xml")
                                        .enabled(true)
                                        .description("NUnit Parser"))
                                .cleanWorkingDirectory(true)))
                .linkedRepositories("SampleProject")
                .triggers(new BitbucketServerTrigger())
                .planBranchManagement(new PlanBranchManagement()
                        .createForVcsBranch()
                        .delete(new BranchCleanup()
                            .whenRemovedFromRepositoryAfterDays(7)
                            .whenInactiveInRepositoryAfterDays(30))
                        .notificationForCommitters()
                        .issueLinkingEnabled(false))
                .forceStopHungBuilds();
            return plan;
        }

        public PlanPermissions PlanPermission()
        {
            PlanPermissions planPermission = new PlanPermissions(new PlanIdentifier("DBS", "SB"))
                .permissions(new Permissions()
                        .userPermissions("admin", PermissionType.ADMIN, PermissionType.VIEW, PermissionType.CLONE, PermissionType.BUILD, PermissionType.EDIT));
            return planPermission;
        }

        public static void Main(string[] args)
        {
            //By default credentials are read from the '.credentials' file.
            BambooServer bambooServer = new BambooServer("http://bamboo-server:8085");
            var planSpec = new PlanSpec();

            Plan plan = planSpec.Plan();
            bambooServer.publish(plan);

            PlanPermissions planPermission = planSpec.PlanPermission();
            bambooServer.publish(planPermission);
        }
    }
}