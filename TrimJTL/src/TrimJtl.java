/**
 * Created by chamara on 4/26/17.
 */
import java.io.*;

public class TrimJtl {

    public static void main(String[] args) {

        final String inputFILENAME = args[0];
        final String outputFILENAME = args[1];

        try (BufferedReader br = new BufferedReader(new FileReader(inputFILENAME))) {

            String sCurrentLine;
            long[] jtlTimeStamps = new long[100000000];
            int i = 0;
            int timelimit = (Integer.parseInt(args[2]))*60*1000;
            //int timelimit = 120*1000;

            String sFirstLine = br.readLine();

            BufferedWriter bw = new BufferedWriter(new FileWriter(outputFILENAME));
            bw.write(sFirstLine);
            bw.newLine();

            while ((sCurrentLine = br.readLine()) != null) {
                String[] elements=sCurrentLine.split(",");
                jtlTimeStamps[i] = Long.parseLong(elements[0]);
                long diff = jtlTimeStamps[i] - jtlTimeStamps[0];
                if ( diff > timelimit) {
                        bw.write(sCurrentLine);
                        bw.newLine();
                }
                i++;
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
