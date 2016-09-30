
proc classdump {o} {
                foreach var [$o vars] {
                        puts [format {%20s %s} $var [$o get $var]]
                }
        }
}

