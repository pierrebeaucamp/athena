import sys
import os
import subprocess as proc
import distutils.spawn as which

version = sys.version[:3]
activate_env_path = os.path.join("env", "bin", "activate_this.py")
activate_env = activate_env_path
opts = {}

def has_colours(stream):
  if not hasattr(stream, "isatty"):
    return False
  if not stream.isatty():
    return False
  try:
    import curses
    curses.setupterm()
    return curses.tigetnum("colors") > 2
  except:
    return False

def print_color(text, color = 7):
  if has_colours(sys.stdout):
    seq = "\x1b[1;%dm" % (30 + color) + text + "\x1b[0m"
    return seq
  else:
    return text

dependencies = ["pandoc", "pandoc-citeproc",
                "pandoc-crossref", "pandoc-sidenote",
                "virtualenv"]

if version != "2.7":
  error = "[ERR]\tPython version not 2.7"
  print(print_color(error, 1))
  sys.exit()

for dependency in dependencies:
  if not which.find_executable(dependency):
    error = "[ERR]\t" + dependency + " not found in path"
    print(print_color(error, 1))
    sys.exit()

print(print_color("==> Creating the virtual environment. . .", 4))
try:
  proc.check_call(["virtualenv", "env"])
except Exception, e:
  raise e

print(print_color("==> Activating the virtual environment. . .", 4))
execfile(activate_env, dict(__file__=activate_env))

print(print_color("==> Installing pip dependencies. . .", 4))
proc.check_call(["pip", "install", "-r", "requirements.txt"])

try:
  print(print_color("==> Customizing athena. . .", 4))
  opts["title"] = raw_input(
      print_color("Enter title: ", 4)
    )
  opts["author"] = raw_input(
      print_color("Enter author: ", 4)
    )
  opts["indexdesc"] = raw_input(
      print_color("Enter home page description: ", 4)
    )
  opts["sidebardesc"] = raw_input(
      print_color("Enter sidebar description: ", 4)
    )
  opts["footer"] = raw_input(
      print_color("Enter footer: ", 4)
    )
except KeyboardInterrupt:
  print("\n")
  sys.exit()

with open("config.py", 'w') as f:
  f.write("config = {\n")
  for key, value in opts.items():
    f.write('\t"%s"\t: "%s",\n' % (key, value))
  f.write("}\n")

print(print_color("==> Installation complete!", 2))
