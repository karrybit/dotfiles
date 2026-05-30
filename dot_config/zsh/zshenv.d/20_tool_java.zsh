mkdir -p "$XDG_CONFIG_HOME/java"

export _JAVA_OPTIONS=-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java

path=(/opt/homebrew/opt/openjdk/bin $path)
