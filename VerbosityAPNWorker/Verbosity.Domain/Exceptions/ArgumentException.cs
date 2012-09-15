using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Verbosity.Domain.Exceptions
{
    public sealed class ArgumentException : Verbosity.Domain.Exceptions.Exception
    {
        private System.ArgumentException _arg_exp;
        public ArgumentException(string argument, string message) : base(message)
        {
            _arg_exp = new System.ArgumentException(argument, message);
        }
        public ArgumentException(string message)
            : base(message)
        {
            _arg_exp = null;
        }

        public new string Message
        {
            get
            {
                return _arg_exp.Message;
            }
        }
    }
}
