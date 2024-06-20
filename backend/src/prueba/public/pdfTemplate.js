module.exports = (dataInfo) => {
  const data = dataInfo.publicaciones;

  const today = new Date();
  const groupedData = {};

  data.forEach((item) => {
    if (!groupedData[item.titulo]) {
      groupedData[item.titulo] = [];
    }
    groupedData[item.titulo].push(item);
  });

  return `
     <!doctype html>
     <html>
     <head>
       <meta charset="utf-8" />
       <title>PDF Result Template</title>
       <style>
   
       .cont-info {
        display: table;
        width: 100%;
    }
    .cont-info > div {
        display: table-cell;
        text-align: center;
        vertical-align: middle;
        padding: 5px; /* Reducido a 5px */
    }
    .cont-info img {
        max-width: 78px; /* Reducido a la mitad */
        width: 100%;
    }
    .text-title {
        font-size: 8px; /* Reducido a la mitad */
        font-weight: bold;
        margin: 2.5px 0; /* Reducido a la mitad */
        color: var(--mainBlue); /* Manteniendo el color original */
        font-family: "Roboto", sans-serif; /* Manteniendo la fuente original */
        white-space: nowrap; /* Agregado para evitar saltos de línea */
    }

    .cont-info2 {
      display: flex;
      justify-content: space-between;
      width: 100%;
      max-width: 500px; /* Reducido a la mitad */
      margin: 0 auto;
    }

    .column {
      width: 12.5%; /* Reducido a la mitad */
      padding: 5px; /* Reducido a 5px */
      margin: 0 5px; /* Reducido a 5px */
      box-sizing: border-box;
      background-color: #f0f0f0;
    }

    .invoice-box {
      max-width: 750px; /* Reducido a la mitad */
      margin: auto;
      padding: 15px; /* Reducido a 15px */
      border: 0.5px solid #eee; /* Reducido a 0.5px */
      box-shadow: 0 0 5px rgba(0, 0, 0, .15); /* Reducido el efecto de sombra */
      font-size: 8px; /* Reducido a la mitad */
      line-height: 12px; /* Reducido a la mitad */
      font-family: 'Helvetica Neue', 'Helvetica';
      color: #555;
    }

   
              .margin-top {
              margin-top: 50px;
              }
   
              .justify-center {
              text-align: center;
              }
   
              .invoice-box table {
              width: 100%;
              line-height: inherit;
              text-align: left;
              }
   
              .invoice-box table td {
              padding: 5px;
              vertical-align: top;
              }
   
   
   
              .invoice-box table tr.top table td {
              padding-bottom: 20px;
              }
   
              .invoice-box table tr.top table td.title {
              font-size: 45px;
              line-height: 45px;
              color: #333;
              }
   
              .invoice-box table tr.information table td {
              padding-bottom: 40px;
              }
   
              .invoice-box table tr.heading td {
              background: #eee;
              border-bottom: 1px solid #ddd;
              font-weight: bold;
              }
   
              .invoice-box table tr.details td {
              padding-bottom: 20px;
              }
   
              .invoice-box table tr.item td {
              border-bottom: 1px solid #eee;
              }
              .cont-info {
               display: flex;
               flex-direction: row;
               justify-content: space-between;
             }
   
   
              .invoice-box table tr.item.last td {
              border-bottom: none;
              }
   
              .invoice-box table tr.total td:nth-child(2) {
              border-top: 2px solid #eee;
              font-weight: bold;
              }
   
              @media only screen and (max-width: 600px) {
              .invoice-box table tr.top table td {
              width: 100%;
              display: block;
              text-align: center;
              }
   
              .invoice-box table tr.information table td {
              width: 100%;
              display: block;
              text-align: center;
              }
              }
       </style>
     </head>
     <body>
       <div class="cont-info">
         <div>
           <img
             src="https://res.cloudinary.com/dmkvix7ds/image/upload/v1691793446/descarga_e32xnn.png"
           />
         </div>
         <div>
           <h1 class="text-title">UNIVERSIDAD DE LAS FUERZAS ARMADAS - ESPE</h1>
           <h1 class="text-title">REPORTE DE EMERGENCIAS COMUNITARIAS</h1>
         </div>
         <div>
           <img
             src="https://res.cloudinary.com/dmkvix7ds/image/upload/v1691793446/logo_gx8oxe.png"
           />
         </div>
       </div>

    <div class="cont-info">
       <div class="column">
         <div class="text-title">Usuario registrado</div>
         <div>${dataInfo.totalUsuarios}</div>
       </div>
       <div class="column">
         <div class="text-title">Publicaciones registradas</div>
         <div>${dataInfo.totalPublicacionesCoutn}</div>
       </div>
       <div class="column">
         <div class="text-title">Publicaciones por mes</div>
         <div>${dataInfo.totalPublicacionesMes}</div>
       </div>
       <div class="column">
         <div class="text-title">Publicaciones por día</div>
         <div>${dataInfo.totalPublicacionesDia}</div>
       </div>
     </div>
     
    
       <div class="invoice-box">
         <table cellpadding="0" cellspacing="0" class="horizontal-table">
           <tr class="top">
             <td colspan="14">
               <!-- Encabezado aquí -->
               <div class="cont-aling">
                 <div class="text-title">Reporte de Emergencias</div>
                 <div>${today.toLocaleDateString()}</div>
               </div>
             </td>
           </tr>
           <tr class="heading">
             <td colspan="2">Título</td>
             <td colspan="2">Ciudad</td>
             <td colspan="2">Fecha de creación</td>
             <td colspan="2">Fecha de actualización</td>
             <td colspan="2">Hora de creación</td>
             <td colspan="2">Hora de actualización</td>
             <td colspan="2">Cantidad</td>
             <td colspan="2">Porcentaje</td>
           </tr>
           ${Object.entries(groupedData)
             .map(
               ([titulo, items]) => `
           <tr class="item">
             <td colspan="2">${titulo}</td>
             <td colspan="2">${items[0].ciudad}</td>
             <td colspan="2">${items[0].createdAt.toLocaleDateString()}</td>
             <td colspan="2">
               ${items[items.length - 1].updatedAt.toLocaleDateString()}
             </td>
             <td colspan="2">${items[0].createdAt.toLocaleTimeString()}</td>
             <td colspan="2">
               ${items[items.length - 1].updatedAt.toLocaleTimeString()}
             </td>
             <td colspan="2">${items.length}</td>
             <td colspan="2">
               ${((items.length / data.length) * 100).toFixed(2)}%
             </td>
           </tr>
           `
             )
             .join("")}
   
           <tr class="total">
             <td colspan="2">Total</td>
             <td colspan="2"></td>
             <td colspan="2"></td>
             <td colspan="2"></td>
             <td colspan="2"></td>
             <td colspan="2"></td>
             <td colspan="2">${data.length}</td>
             <td colspan="2">100%</td>
           </tr>
         </table>
       </div>
     </body>
   </html>
   
     `;
};
