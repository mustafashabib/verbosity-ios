using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Exceptions
{
    internal class Exception : System.Exception
    {
        public Exception();
        public Exception(string message) : base(message) { }
        public Exception(System.Exception ex) : base(ex) { }
        public Exception(string message, System.Exception ex) : base(message, ex) { }
    }
}
