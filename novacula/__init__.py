__all__ = []


from rich_argparse import RichHelpFormatter

def get_argparser_formatter():
  RichHelpFormatter.styles["argparse.args"]     = "green"
  RichHelpFormatter.styles["argparse.prog"]     = "bold grey50"
  RichHelpFormatter.styles["argparse.groups"]   = "bold green"
  RichHelpFormatter.styles["argparse.help"]     = "grey50"
  RichHelpFormatter.styles["argparse.metavar"]  = "blue"
  return RichHelpFormatter