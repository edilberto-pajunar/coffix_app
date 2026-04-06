export function wrapInEmailShell(content: string): string {
  const logoUrl = process.env.LOGO_URL ?? "";

  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  </head>
  <body style="margin:0;padding:32px 0;background-color:#f5f5f5;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;">
    <table width="900" align="center" cellpadding="0" cellspacing="0" border="0" style="background-color:#ffffff;border:none;border-collapse:collapse;">
      <tr>
        <td align="center" style="padding:32px 0 16px;">
          <img src="${logoUrl}" alt="Coffix" height="48" style="display:block;" />
        </td>
      </tr>
      <tr>
        <td style="padding:24px 48px 48px;color:#1a1a1a;font-size:14px;line-height:1.6;">
          ${content}
        </td>
      </tr>
    </table>
  </body>
</html>`;
}
