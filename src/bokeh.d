module bokeh.bokeh;
import bokeh.js;
import bokeh.glyphs;
import bokeh.display;
import bokeh.generate;
import bokeh.plot;

struct BokehGlobal
{
  bool debug = false;  // display indented JSON, uses unminified js and saves the raw JSON to "bokeh_models.json"
  bool autopen = true; // whether or not to show the plot immediately after `plot`
  double width = 800.0; // default width of plot
  long height = 600.0;
  X_AXIS_TYPE = :auto;
  Y_AXIS_TYPE = :auto;
  DEFAULT_GLYPHS_STR = "b|r|g|k|y|c|m|b--|r--|g--|k--|y--|c--|m--|--";
  DEFAULT_GLYPHS = Glyphs(DEFAULT_GLYPHS_STR);
  int DEFAULT_SIZE = 6; // default glyph size
  int DEFAULT_FILL_ALPHA = 0.7; # default alpha value for filled glyphs
  string PLOTFILE = "bokeh_plot.html"; // default filename 
  string TITLE = "Bokeh Plot";
  long COUNTEVAL = 500;

  void plotfile(string fn)
  {
    this.plotFile=fn;
    warn_overwrite();
  }

string warn_overwrite()
{
  return ispath(PLOTFILE) && isinteractive() && !isdefined(Main, :IJulia) && warn(
  "$PLOTFILE already exists, it will be overwritten when a plot is generated.\nChange the output file with plotfile(<new file name>)");
}

static this
{
  warn_overwrite();
}


# hold on to plots
HOLD = false
function hold(h::Bool, clear::Union(Bool, Nothing)=nothing)
    if (!h && clear == nothing) || clear == true
        global CURPLOT = nothing
    end
    global HOLD = h
end
hold() = hold(!HOLD)

Curplot CURPLOT = nothing // current plot object

Tools TOOLS = Tools(Tool.pan, Tool.wheelzoom, Tool.boxzoom, Tool.resize, Tool.reset);
// tools to add to display

bool WARN_FILE = nothing;
// to avoid giving the same warning lots of times remember the file we've
// just warned about overwriting

bool NOSHOW = false;
// this overrides autoopen and disables opening html files
// used for travis CI, shouldn't be necessary elsewhere
bool INCLUDE_JS = false;
bool FILE_WARNINGS = true; //filesystem warning switch
