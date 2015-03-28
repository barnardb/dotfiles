import com.timushev.sbt.updates.UpdatesPlugin.autoImport._

dependencyUpdatesExclusions :=
  moduleFilter(
    organization = ScalaArtifacts.Organization,
    name = ScalaArtifacts.LibraryID,
    revision = { version: String =>
      val binaryVersion = CrossVersion.binaryScalaVersion(version)
      //println(s"Scala binary: ${scalaBinaryVersion.value}, version: , cand binary: ${binaryVersion}")
      scalaBinaryVersion.value != binaryVersion &&
        crossScalaVersions.value.map(CrossVersion.binaryScalaVersion).contains(binaryVersion)
    }
  )
