isRoot()
{
  if [ `/usr/bin/id -u` -eq 0 ]; then
      return true;
  fi

  return false;
}

isRoot();