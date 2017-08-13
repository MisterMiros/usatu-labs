using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Threading.Tasks;

namespace RGRAppSharp
{
    class Program
    {
        static String location;
        static DateTime time;

        static void Main()
        {
            Console.WriteLine(A.Value);
            Console.WriteLine(B.Value);
            Console.ReadLine();
        }
    }

    public class A
    {
        public static int Value;
        public A()
        {
            Value = 10;
        }
    }

    public class B : A
    {
        public static new int Value;
        static B()
        {
            B.Value = 15;
        }
    }
}
