function JavaScriptFunction(inputFunction)
{
  this.inputFunction = inputFunction;
  this.str = null;
  this.name = null;
  this.arguments = null;
  this.argumentsString = null;
  this.spec = null;
  this.callee = null;
  this.rootFunction = null;
  
  this.getName = JavaScriptFunction_getName;
  this.getSpec = JavaScriptFunction_getSpec;
  this.toString = JavaScriptFunction_toString;
  this.getArguments = JavaScriptFunction_getArguments;
  this.getArgumentsString = JavaScriptFunction_getArgumentsString;
  this.getRootFunction = JavaScriptFunction_getRootFunction;
  this.getCallee = JavaScriptFunction_getCallee;
  
  this.str = this.inputFunction.toString();
  this.name = constructorName(this.inputFunction);
  
  this.spec = this.name + "(" + this.getArgumentsString() + ")";
  this.str = this.inputFunction.toString();
  if(this.inputFunction.caller)
  {
    this.caller = new JavaScriptFunction(this.inputFunction.caller);
    this.caller.callee = this;
  }
  else
  {
    this.caller = null;
  }
  
}
  function JavaScriptFunction_getName()
  {
    return this.name;
  }
  function JavaScriptFunction_getSpec()
  {
    if(this.spec == null)
    {
    }
    
    return this.spec;
  }
  function JavaScriptFunction_toString(depth)
  {
    return this.str;
  }
  function JavaScriptFunction_getArguments()
  {
    if(this.arguments == null)
    {
      this.arguments = this.getArgumentsString().split(",");
    }
    
    return this.arguments;
  }
  function JavaScriptFunction_getArgumentsString()
  {
    if(this.argumentsString == null)
    {
      var beginArgs = this.toString().indexOf("(") + 1;
      var endArgs = this.toString().indexOf(")");
      
      this.argumentsString = this.toString().substring(beginArgs, endArgs);

    }
    
    return this.argumentsString;
  }
  function JavaScriptFunction_getRootFunction()
  {
    if(this.rootFunction == null)
    {
      var caller = this;
      while(caller != null)
      {
        this.rootFunction = caller;
        caller = caller.caller;
      }
    }
    
    return this.rootFunction;
  }
  function JavaScriptFunction_getCallee()
  {
    return this.callee;
  }
