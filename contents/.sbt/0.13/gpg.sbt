import com.typesafe.sbt.SbtPgp.autoImport._

useGpg := true

PgpKeys.gpgCommand in Global := "gpg2"
