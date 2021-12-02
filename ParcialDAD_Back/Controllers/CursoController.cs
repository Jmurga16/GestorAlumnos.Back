using Business;
using Entity;
using Microsoft.AspNetCore.Mvc;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ParcialDAD_Back.Controllers
{
    [Route("CursoService")]
    [ApiController]
    public class CursoController : Controller
    {
        private readonly CursoBusiness objBusiness = new CursoBusiness();
        private readonly Logger logger = LogManager.GetCurrentClassLogger();

        #region CRUD Curso

        [HttpPost]
        public IActionResult CrudCurso(GeneralEntity genEnt)
        {

            if (genEnt.sOpcion == "01" || genEnt.sOpcion == "02")
            {
                try
                {
                    var vRes = objBusiness.BusinessCurso(genEnt);

                    return Ok(vRes);
                }
                catch (Exception e)
                {

                    logger.Error(e);
                    throw;

                }
            }

            else if (genEnt.sOpcion == "03" || genEnt.sOpcion == "04" || genEnt.sOpcion == "05")
            {
                try
                {
                    string[] listaRes;

                    string sResultado = Convert.ToString(objBusiness.BusinessCurso(genEnt));
                    listaRes = sResultado.Split('|');

                    return Ok(new { cod = listaRes[0], mensaje = listaRes[1] });
                }
                catch (Exception e)
                {

                    logger.Error(e);
                    throw;

                }
            }

            else
            {
                return null;
            }

        }

        #endregion
    }
}
