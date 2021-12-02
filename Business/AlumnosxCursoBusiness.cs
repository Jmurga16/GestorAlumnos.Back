using Data;
using Entity;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business
{
    public class AlumnosxCursoBusiness
    {
        private readonly AlumnosxCursoData alumnosxCursoData = new AlumnosxCursoData();
        private readonly Logger logger = LogManager.GetCurrentClassLogger();


        public object BusinessAlumnosxCurso(GeneralEntity genEnt)
        {
            try
            {

                return alumnosxCursoData.DataAlumnosxCurso(genEnt);

            }
            catch (Exception e)
            {
                logger.Error(e);
                throw;

            }
        }
    }
}
