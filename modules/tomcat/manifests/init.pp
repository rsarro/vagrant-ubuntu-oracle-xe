group { 'puppet': ensure => 'present' }
# update the (outdated) package list

class tomcat::java_6 {
	exec { "update-package-list":
		command => "/usr/bin/sudo /usr/bin/apt-get update",
	}
	package { "openjdk-6-jdk":
		ensure => installed,
		require => Exec["update-package-list"],
	}
}
class tomcat::tomcat_6 {
	package { "tomcat6":
		ensure => installed,
		require => Package['openjdk-6-jdk'],
	}
	package { "tomcat6-admin":
		ensure => installed,
		require => Package['tomcat6'],
	}
	service { "tomcat6":
		ensure => running,
		require => Package['tomcat6'],
		subscribe => File["tomcat-users.xml"]
	}
	file { "tomcat-users.xml":
		owner => 'root',
		path => '/etc/tomcat6/tomcat-users.xml',
		require => Package['tomcat6'],
		notify => Service['tomcat6'],
		source => "puppet:///modules/tomcat/tomcat-users.xml"
#		content => template("tomcat/tomcat-users.xml.erb")

	}
}
# set variables

#include java_6
#include tomcat_6
